document.addEventListener('DOMContentLoaded', function() {
  const scheduleContainer = document.getElementById('schedule-container');
  
  if (scheduleContainer) {
    new Sortable(scheduleContainer, {
      group: 'schedule-items',
      animation: 150,
      ghostClass: 'sortable-ghost',
      chosenClass: 'sortable-chosen',
      dragClass: 'sortable-drag',
      
      onEnd: function(evt) {
        updatePositions();
      }
    });
  }
  
  function updatePositions() {
    const items = document.querySelectorAll('.schedule-item');
    const positions = [];
    
    items.forEach((item, index) => {
      const dayContainer = item.closest('.day-container');
      const dayNumber = dayContainer.dataset.dayNumber;
      
      positions.push({
        id: item.dataset.itemId,
        position: index + 1,
        day_number: dayNumber
      });
    });
    
    // サーバーに位置情報を送信
    fetch(`/plans/${planId}/schedule_items/update_positions`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ positions: positions })
    });
  }
});
