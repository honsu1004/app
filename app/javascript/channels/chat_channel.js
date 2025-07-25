import consumer from "./consumer"

document.addEventListener("DOMContentLoaded", () => {
  const chatMessages = document.getElementById("chat-messages");
  if (!chatMessages) return;

  const planId = chatMessages.dataset.planId;

  consumer.subscriptions.create(
    { channel: "ChatChannel", plan_id: planId },
    {
      received(data) {
        chatMessages.insertAdjacentHTML("beforeend", data.message);
        chatMessages.scrollTop = chatMessages.scrollHeight;
      }
    }
  );
});
