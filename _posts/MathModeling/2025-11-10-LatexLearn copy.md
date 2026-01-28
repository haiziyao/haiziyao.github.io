---
layout:     post
title:      "Latex Learn"
subtitle:   " \"prepare for MathModeling\""
date:       2025-11-10 00:00:00
author:     "HJL's team(hzy jxt lxx)"
header-img: ""
catalog: true
tags:
    - MathModeling
---

##### For latex user, or for every member, you are expected for "Using Latex"

**预计花费时间4-8小时**


#### 准备工作
##### 下载软件
对于不想配置复杂的软件环境这种情况，极其推荐直接使用[overleaf](https://cn.overleaf.com/)

拓展提升(可以直接无视)：可以自行配置软件环境(自选其一，懒人推荐第一个)
* TeXstudio
* vscode + latex

##### 了解latex | overleaf
自行到b站搜索教程(预计2-4小时)
推荐：
* [overleaf_learn](https://www.bilibili.com/video/BV1cg411V7hW?vd_source=8764f6c9f32bdb5a73fbda89a5f547f5)
* [latex_learn](https://www.bilibili.com/video/BV1Mc411S75c?vd_source=8764f6c9f32bdb5a73fbda89a5f547f5)

##### 作业：练手
根据上面教程文档，请自己编写一个latex的项目(预计1-2小时)：
* 在overleaf中新建项目，并开启共享模式，并分享链接。如：[我的共享](https://cn.overleaf.com/read/jrfsvfdxfqpp#4f43b5)
* 作业内容需要包括：三级标题的使用，如何生成目录，图片的引用，数学公式的书写
* 学会如何使用模板

#### latex 进阶
>完成面内容后，请在以后的各种作业中尝试使用latex而不是word。
在进行这一步之前，请确保你完成了之前的内容。

#### 模板的使用
我们学校有一个大佬做了一个美赛论文模板[美赛论文模板](https://github.com/xjtu-blacksmith/easymcm/releases)
* 在latex中利用这个模板创建一个新项目，并开启共享，将共享地址发送到微信群中(模板我也会以zip的方式发送到群中)
* 参考国赛O奖论文，学习了解每一部分的latex代码编辑的位置是什么
* 请将模板按照下面要求进行内容修改:
    * 将我们选择的题号改为C题
    * 将我们的队伍编号改为2025250
    * 将论文标题改为“A MCM Paper Made by [your name]”
    * 请修改摘要，并填充以下内容到摘要
    >Global warming, El Niño... With the emergence of various extreme climates,\textbf{Austral-ia's wildfires} occur more frequently. The greenhouse gases emitted after combustion have exacerbated global warming, which seems to have entered an endless loop. At the same time, hundreds of millions of lives have been killed in the fire, which makes us sad. In order to better control wildfires, we modeled the \textbf{distribution of drones} assisting in the observation to achieve the best balance between economy and efficiency.
	Several models are established: Model I: Rasterized Multi-Objective Optimization Model; Model II: Model Verification Simulated by Poisson Process; Model III: Hovering Model Based on Tabu Search, etc.
	For Model I: According to the \textbf{heat map} about distribution of fires in Victoria in recent years, we found that the main fire areas are the plains along the eastern coast. Inspired by weights and \textbf{Multi-Objective Optimization} algorithms, we built a brand-new model to find the best location for EOCs and draw up a suitable hover position and reconnaissance route for the drone. Based on the different positions of the fire site, calculate the maximum num-ber of two types of drones and their ratio. The results are shown in Figure 9.
	For Model II: This model is actually a supplement to Model I. In the Model I, the fire only appeared in a small area, and there was a possibility of extreme fire events in the study area. Combining the data about nearly half a century and using the \textbf{Poisson Distribution }to obtain the probability and mathematical expectation, it can be concluded that 2.99431 ex-treme fire events may occur in the next ten years, which is approximately considered to be 3 times. After that, use the mobile EOC to deal with extreme fire events, and utilize the method of Model I to rebuild the drone network to find out what equipment costs need to be increased. Due to the diversity of the results, it will be shown in section 6.2.
	For Model III: To tackle the problem of how to optimize the hover position of drones in different terrains, the \textbf{Tabu Search }algorithm (TS) is a good choice. Using the Tabu Search algorithm can make the hover position of the drones achieve the global optimal ef-fect under different terrain conditions. Since drone signals are severely interfered in urban areas, the reasonable distribution of EOCs enables it to quickly network to respond to sud-den urban fires. The obstruction of mountainous terrain restricts the drone's flying range. Therefore, dividing the area into blocks and managing them separately can effectively im-prove efficiency.
	Finally, sensitivity analysis of the mathematical expectation of extreme fire events $\xi$ shows that our model is not sensitive to changes in $\xi$ , that is, it can be applied to areas with different extreme fire invents. Meanwhile, robustness of our model has also been tested. While adding 5\% random disturbance to $d_{k i}^{\alpha}$  and $d_{k i}^{\beta}$ , the maximum time error is 3.2657\%. The model can be considered stable. Afterwards, a Budget Request supported by our stable models has been written for CFA.
    * 请参照源代码，打开keywords ,内容如下
    >Keywords:Fighting Wildfires; Multi-Objective Optimization; Poisson Distribution; Tabu Search Algorithm; Sensitivity Analysis
    * 插入图片

    ``` latex
    \begin{figure}[htbp]  %h此处，t页顶，b页底，p独立一页，浮动体出现的位置
		\centering  %图表居中
		\includegraphics[width=.7\textwidth]{img/1.png} %图片的名称或者路径之中有空格会出问题 
		\caption{Fire Situation in Australia (Feb 2020 - Feb 2021)} % 图片标题 
		\label{fig:Fire Situation} % 图片标签，可以不写
	\end{figure}
    ```
    这里需要说明的是文件地址的概念：你的图片位于哪里。
    我建议直接放进img文件夹中，然后按照我上面示例进行修改
* 三线格和数学公式
找到notation位置，我们需要将全文用到的变量在此处给予定义和说明
``` latex
\begin{table}[!htbp]
\begin{center}
\caption{Notations}
\begin{tabular}{cl}
	\toprule
	\multicolumn{1}{m{3cm}}{\centering Symbol}
	&\multicolumn{1}{m{8cm}}{\centering Definition}\\
	\midrule
	$v^{(t)}_{ij}$&the first one\\
	$d^{water}_{i}$&the second one\\
	$\alpha^{2}$ &the last one\\
	\bottomrule
\end{tabular}\label{tb:notation}
\end{center}
\end{table}
```
使用我的代码替换你的代码，看看有什么不一样，并学会如何书写上下脚标
* 数学公式的书写(请自行插入文件并查看效果)
    * 行公式

    ``` latex
    \begin{equation}\label{eq:heat}
    \frac{\partial u}{\partial t} - a^2 \left( \frac{\partial^2 u}{\partial x^2} + \frac{\partial^2 u}{\partial y^2} + \frac{\partial^2 u}{\partial z^2} \right) = f(x, y, z, t)
    \end{equation}
    ```
    * 大括号方程组

    ``` latex
    \begin{equation}
    \begin{cases}
    x_{ij} \in \{0,1\} & \text{(the $i$ has $j$ ... )} \\
    \sum_{i=1}^k x_{ij} \geq 1 & \text{at least 1 } \\
    \sum_{j=1}^m x_{ij} \leq t_i / t_0 & \text{(limited)}
    \end{cases}
    \end{equation}
    ```
    * 矩阵 和 行列式
    
    ``` latex
    % 矩阵
    \[
    A = \begin{pmatrix}
    a_{11} & a_{12} & \dots & a_{1n} \\
    a_{21} & a_{22} & \dots & a_{2n} \\
    \vdots & \vdots & \ddots & \vdots \\
    a_{m1} & a_{m2} & \dots & a_{mn}
    \end{pmatrix}
    \]

    % 行列式
    \[
    |A| = \begin{vmatrix}
    a_{11} & a_{12} \\
    a_{21} & a_{22}
    \end{vmatrix} = a_{11}a_{22} - a_{12}a_{21}
    \]
    ```

* latex-label生成器

    * [教程文档](https://blog.csdn.net/winycg/article/details/82633513)
    * [latex表格生成器](https://www.latex-tables.com/)

    根据这些可以很轻松制作许多需要的表格