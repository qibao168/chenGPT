# ChenGPT 私有网页部署系统

ChenGPT 是一个极简、私有化部署的 GPT 对话系统网页客户端。前端页面基于原生 HTML + JS，后端使用 Flask 实现，支持对接任意兼容的语言模型服务接口（如本地 FastChat、Ollama、自建 LLM 等）。

---

## 📁 项目结构

chenGPT/
├── index.html # 前端网页
├── server.py # Flask 后端，转发到模型服务
├── requirements.txt # Python 依赖列表
├── .env # 配置模型服务地址
├── run.sh # 快速启动脚本（开发模式）
└── deploy.sh # 一键部署脚本（含 systemd + Nginx + SSL）

yaml
复制
编辑

---

## ⚙️ 环境要求

- Python 3.8+
- pip
- Linux/macOS 服务器（可选 Nginx 与 Certbot）

---

## 🚀 快速启动（开发模式）

### 1. 安装依赖

```bash
pip install -r requirements.txt
2. 配置模型地址
编辑 .env 文件：

bash
复制
编辑
CHENGPT_API=http://localhost:8080/chat
这里请替换为你自己的模型 API 地址

3. 启动服务
bash
复制
编辑
chmod +x run.sh
./run.sh
访问浏览器：

arduino
复制
编辑
http://localhost:5000
🌐 生产部署（带 HTTPS）
适用于公网服务器 + 已绑定域名

bash
复制
编辑
chmod +x deploy.sh
sudo ./deploy.sh your.domain.com
部署内容：

使用 Gunicorn 启动服务（systemd）

自动配置 Nginx 反向代理

自动申请 HTTPS 证书（Let's Encrypt）

🧪 示例 API 返回格式
你的模型服务应接受如下格式请求：

json
复制
编辑
POST /chat
{
  "prompt": "你好"
}
并返回：

json
复制
编辑
{
  "reply": "你好，我是 ChenGPT。"
}
📌 注意事项
本系统无上下文记忆，如需上下文支持，请扩展 server.py 逻辑；

不建议将 OpenAI API Key 直接写入前端；

支持替换为自建服务、FastChat、Ollama 等模型平台。

📮 联系作者
GitHub：@qibao168

