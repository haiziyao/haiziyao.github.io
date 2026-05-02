---
layout:     post
title:      "Spring AI Alibaba"
subtitle:   " \"学好ai应用开发，准备入职\""
date:       2026-4-3 12:00:00
author:     "HZY"
header-img: "img/java/1.png"
catalog: true
tags:
    - java
---


 
## 基础概念

### 快速入门

so eary 

### 相关概念

* token
* 模型参数:
    * 温度: 控制文本生成的随机性，值越低越准确，
    * 核采样
    * 流式输出
    * message
        * system
        * user
        * assiant
        * tool
    * prompt


## SpringAIAlibaba

* 核心升级: 加入了`Graph`

### 基础组件

#### Message

``` java
    @GetMapping("/message")
    public String message(@RequestParam(name = "query") String query){
        SystemMessage systemMessage = new SystemMessage("你是一个智能机器人");
        UserMessage userMessage = new UserMessage(query);

        String call = chatModel.call(systemMessage, userMessage );

        return call;
    }
```

#### Prompt

``` java
    @GetMapping("/chatOptions")
    public ChatResponse chatOptions(@RequestParam(name = "query") String query){
        SystemMessage systemMessage = new SystemMessage("你是一个智能机器人");
        UserMessage userMessage = new UserMessage(query);
        var options = new ZhiPuAiChatOptions.Builder()
                .model("glm-4.5")
                .temperature(0.0)
                .maxTokens(15536)
                .build();
                // 这里的配置会被application.yaml覆盖，目前不知道为啥，学到后面再说
        return chatModel.call(new Prompt(List.of(systemMessage,
                userMessage),options));

        // ChatResponse chatResponse = chatModel.call(new Prompt(List.of(systemMessage,
        // userMessage),options));

        // var result = chatResponse.getResult().getOutput().getText();
        // return result;
    }
```

#### ChatModel

##### 流式

``` java

    // 注意：一定要配置字符集
    @GetMapping("/flux")
    public Flux<String> flux(@RequestParam(name = "query") String query){
        SystemMessage systemMessage = new SystemMessage("你是一个智能机器人");
        UserMessage userMessage = new UserMessage(query);
        var call = chatModel.stream(systemMessage, userMessage );
        return call;
    }
```


#### ChatClient

``` java

     // constructor 注入
    private final ChatClient chatClient;

    public ZhiPuAIClientController(ChatClient.Builder builder  ) {
        this.chatClient = builder.build();
    }

    @GetMapping("/simple")
    public String simple(@RequestParam(name = "query") String query){
        var options = new ZhiPuAiChatOptions.Builder()
                .model("glm-4.5")
                .temperature(0.0)
                .maxTokens(15536)
                .build();
//        不优雅
//        SystemMessage systemMessage = new SystemMessage("你是一个智能机器人");
//        UserMessage userMessage = new UserMessage(query);
//        var result = chatClient.prompt(new Prompt(List.of(systemMessage,
//                userMessage),options))
//                .call().content();
        var result = chatClient.prompt()
                .system("你是一个ai助手")
                .user(query)
                .options(options)
                .call().content();
                //当然这里也可以返回 ChatResponse
        return result;
    }
```

#### Advisors

* 对话记忆
* 敏感词过滤
* RAG检索

##### 介绍

其实就是一个请求前后增强器

* getOrder值越小越早请求
* 这是一个调用链
* `CallAdvisor` 和 `StreamAdvisor`
* `BaseAdvisor` 是上面俩合起来的封装

##### 记忆增强

* 如何区分不同用户
    * session_ID


``` java
// 简单写一下，很多功能没有打磨
public class SimpleMessageChatAdvisor implements BaseAdvisor {

    public static List<Advisor> SimpleMessageChatAdvisor;
    private static Map<String, List<Message>> chatMemory = new HashMap<String, List<Message>>();

    @Override
    public ChatClientRequest before(ChatClientRequest chatClientRequest, AdvisorChain advisorChain) {
        //

        //
        List<Message> messages = chatMemory.get("haiziyao");
        if (messages == null) {
            messages = new ArrayList<Message>();
            chatMemory.put("haiziyao", messages);
        }
        List<Message> instructions = chatClientRequest.prompt().getInstructions();
        messages.addAll(instructions);
        //
        return chatClientRequest.mutate()
                .prompt(chatClientRequest.prompt().mutate().messages(messages).build())
                .build();
    }

    @Override
    public ChatClientResponse after(ChatClientResponse chatClientResponse, AdvisorChain advisorChain) {

        // 找到会话记录
        List<Message> messages = chatMemory.get("haiziyao");
        if (messages == null) {
            messages = new ArrayList<>();
        }
        // 获取response中ai的消息
        if(Objects.isNull(chatClientResponse)){
            return chatClientResponse;
        }
        // 存入
        AssistantMessage output = chatClientResponse.chatResponse()
                .getResult()
                .getOutput();
        messages.add(output);

        return chatClientResponse;
    }

    @Override
    public int getOrder() {
        return 0;
    }
}


```

``` java

    @GetMapping("simplemessageclient")
    public String demo(@RequestParam(name ="query")String query){
        return chatClient.prompt()
                .user(query)
                .system("你是个“疯狂星期四文案”生成器，你需要做的就是生成vivo50的文案，无论用户说啥，你都用文案回复")
                .advisors(advisorSpec -> advisorSpec.param("conID","haiziyao"))
                .advisors(new SimpleMessageChatAdvisor())
                .call()
                .content();
    }

```

##### 使用官方Advisor

`MessageCharMemoryAdvisor`

``` java

    @RestController
    @RequestMapping("/chatclientplus")
    public class ZhiPuCharMemoryController {

        private final ChatClient chatClient;


        public ZhiPuCharMemoryController(ChatClient.Builder builder) {

            MessageWindowChatMemory memory = MessageWindowChatMemory.builder()
                    .maxMessages(20)
                    .build();

            MessageChatMemoryAdvisor advisor = MessageChatMemoryAdvisor.builder(memory).build();


            this.chatClient = builder
                    .defaultAdvisors(advisor)
                    .build();
        }

        @GetMapping("simplemessageclient")
        public String demo(@RequestParam(name ="query")String query,
                        @RequestParam(name = "conversationId")String conversationId){
            return chatClient.prompt()
                    .user(query)
                    .advisors(advisorSpec -> advisorSpec.param(ChatMemory.CONVERSATION_ID,conversationId))
                    .call()
                    .content();
        }
    }
```

* 这里其实几句话说不完
* 如果想自定义，就去实现`ChatMemoryRepository`接口，实现所有方法
* `MessageWindowMemory`的局限性或特性
    * 对话记忆全量保存，只是做了max限制而已


#### Prompt Template

* 提示词拼接不够优雅，所以封装起来
* 不就是`format`吗
* 暂时不给太多例子，因为这个也不好用。
* 我更倾向于那种`read from file`




### RAG

* Retrieval-Augmented Generation 检索增强生成

* 文本转向量
* Embedding嵌入
* EmbeddingModle嵌入模型
* 向量数据库库
* 向量维度


#### quick-start


##### 构建向量知识库

``` java
@GetMapping("/import")
    public String importCoffee() {
        try {
            ClassPathResource resource = new ClassPathResource("QA.csv");
            InputStreamReader isr = new InputStreamReader(resource.getInputStream());
            CSVParser csvParser = CSVFormat.DEFAULT.builder()
                    .setHeader()
                    .setSkipHeaderRecord(true)
                    .build()
                    .parse(isr);
            List<Document> documents = new ArrayList<Document>();
            for (CSVRecord record : csvParser) {
                String question = record.get("问题");
                String answer = record.get("回答");
                String content = "问题:" + question + "\n回答"+ answer;
                Document document = new Document(content);
                documents.add(document);
            }
            csvParser.close();
            vectorStore.add(documents);
            return "成功导入 " + documents.size()+ "条数据到向量数据库";
        }catch (Exception e) {
            e.printStackTrace();
            return "导入失败"+e.getMessage();
        }
    }
```


### ToolCalling


``` java
    @Tool(description = "通过时区id获取当前时间")
    public String getTimeByZoneId(@ToolParam(description = "时区id, 比如 Asia/Shanghai")
                                  String zoneId) {
        ZoneId zid = ZoneId.of(zoneId);
        ZonedDateTime zonedDateTime = ZonedDateTime.now(zid);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss z");
        return zonedDateTime.format(formatter);
    }

```

* 这个怎么测都测不出来，烦死我了


### MCP

* MCP host
* MCP client
* MCP server


调包侠进阶



### Graph

* 为什么需要Graph
    * 实际的工作是一个工作流
    * 需要步骤
    * 需要各种行为

* 核心概念
    * 节点
    * 边（条件边）


#### KeyStrategyFactory

``` java

KeyStrategyFactory keyStrategyFactory = new KeyStrategyFactoryBuilder()
        .addStrategy("input1", KeyStrategy.REPLACE)
        .addStrategy("input2",KeyStrategy.MERGE)
        .addStrategy("input3",KeyStrategy.APPEND)
        .build();
         
```

* 替换
* 合并
* 追加


#### NodeAction & AsyncNodeAction

``` java

stateGraph.addNode("node1", AsyncNodeAction.node_async(node ->{
    return Map.of("input1",1);
}));

```

#### StateGraph

``` java

    @Bean("simpleGraph")
    public CompiledGraph simpleGraph() throws GraphStateException {

        KeyStrategyFactory keyStrategyFactory = new KeyStrategyFactoryBuilder()
                .addStrategy("sentence",KeyStrategy.REPLACE)
                .addStrategy("word",KeyStrategy.REPLACE)
                .build();

        StateGraph stateGraph = new StateGraph("simpleGraph", keyStrategyFactory);

        stateGraph.addNode("SentenceConstructionNode",AsyncNodeAction.node_async(new SentenceConstrucrionNode(chatClient)));
        stateGraph.addNode("translateNode",AsyncNodeAction.node_async(new TranslateNode(chatClient)));


        stateGraph.addEdge(StateGraph.START,"SentenceConstructionNode");
        stateGraph.addEdge("SentenceConstructionNode","translateNode");
        stateGraph.addEdge("translateNode",StateGraph.END);
        return stateGraph.compile();
    }

```

#### 循环分支控制语句

##### 条件边

``` java

stateGraph.addConditionalEdges("评估笑话", AsyncEdgeAction.edge_async(
                        state -> state.value("result","优秀")),
                Map.of("优秀",StateGraph.END,
                        "不够优秀","优化笑话"));

```

##### 循环

就是基于条件实现的，只不过在状态中存储了一个用来检验循环次数的值而已

##### 状态存储

对于一些信息或者数据，我们可以使用追加，就是定义keystrateFactory的时候

也可以使用我们的状态存储，可以做对话区分

默认使用的都是ThreadLocal


##### 可视化

``` java


```


## 项目