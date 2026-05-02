# 指定使用 bash 执行，确保 read -p 能够正常工作
SHELL := /bin/bash

# 声明伪目标，防止和同名文件冲突
.PHONY: post push

post:
	@read -p "请输入文章标题 (title): " TITLE; \
	if [ -z "$$TITLE" ]; then \
		echo "❌ 错误：标题不能为空！"; \
		exit 1; \
	fi; \
	read -p "请输入分类 (category): " CATEGORY; \
	read -p "请输入副标题 (subtitle): " SUBTITLE; \
	read -p "请输入作者 (author): " AUTHOR; \
	DATE_FILE=$$(date +"%Y-%-m-%-d"); \
	DATE_CONTENT=$$(date +"%Y-%-m-%-d %H:%M:%S"); \
	DIR_PATH="_posts/$$CATEGORY"; \
	FILE_PATH="$$DIR_PATH/$$DATE_FILE-$$TITLE.md"; \
	mkdir -p "$$DIR_PATH"; \
	echo "---" > "$$FILE_PATH"; \
	echo "layout:     post" >> "$$FILE_PATH"; \
	echo "title:      \"$$TITLE\"" >> "$$FILE_PATH"; \
	echo "subtitle:   \" \\\"$$SUBTITLE\\\"\"" >> "$$FILE_PATH"; \
	echo "date:       $$DATE_CONTENT" >> "$$FILE_PATH"; \
	echo "author:     \"$$AUTHOR\"" >> "$$FILE_PATH"; \
	echo "header-img: \"\"" >> "$$FILE_PATH"; \
	echo "catalog: true" >> "$$FILE_PATH"; \
	echo "tags:" >> "$$FILE_PATH"; \
	echo "    - $$CATEGORY" >> "$$FILE_PATH"; \
	echo "---" >> "$$FILE_PATH"; \
	echo ""; \
	echo "✅ 成功生成博客模板: $$FILE_PATH"

push:
	@read -p "请输入 commit 描述 [默认: update blog]: " MSG; \
	MSG=$${MSG:-update blog}; \
	echo "🔧 正在配置 Git 身份信息..."; \
	git config user.name "haiziyao"; \
	git config user.email "1754203003@qq.com"; \
	echo "🚀 正在执行 git add ."; \
	git add .; \
	echo "📝 正在执行 git commit -m \"$$MSG\""; \
	git commit -m "$$MSG"; \
	echo "☁️ 正在执行 git push"; \
	git push; \
	echo "✅ 所有修改已成功推送到远程仓库！"


	