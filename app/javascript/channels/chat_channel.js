import consumer from "./consumer"

document.addEventListener("DOMContentLoaded", () => {
  const chatMessages = document.getElementById("chat-messages");
  if (!chatMessages) return;

  const planId = chatMessages.dataset.planId;
  
  // ActionCableでの受信処理
  const subscription = consumer.subscriptions.create(
    { channel: "ChatChannel", plan_id: planId },
    {
      received(data) {
        if (data.type === "ping") return;
        
        if (data.message) {
          // 最下部に追加
          chatMessages.insertAdjacentHTML("beforeend", data.message);
          chatMessages.scrollTop = chatMessages.scrollHeight;
        }
      }
    }
  );

  // 送信処理
  const messageForm = document.getElementById("chat-form");
  const messageInput = document.getElementById("message-input");
  
  if (messageForm && messageInput) {
    messageForm.addEventListener("submit", (e) => {
      e.preventDefault();
      
      const content = messageInput.value.trim();
      if (content === "") return;
      
      // Ajax送信
      fetch(`/plans/${planId}/chat_messages`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          chat_message: {
            content: content
          }
        })
      })
      .then(response => {
        if (response.ok) {
          messageInput.value = "";
        } else {
          console.error("メッセージ送信に失敗しました");
        }
      })
      .catch(error => {
        console.error("エラー:", error);
      });
    });
  }
});
