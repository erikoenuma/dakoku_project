// 現在時刻を動的に表示する
document.addEventListener('turbolinks:load', () => {

    var hour = document.getElementById("hour");
    var min = document.getElementById("min");
    var sec = document.getElementById("sec");

    setInterval(updateTime, 1000)

    function updateTime() {
        const date = new Date();
        const hours = date.getHours();
        const minutes = date.getMinutes();
        const seconds = date.getSeconds();

        hour.innerHTML = String(hours).padStart(2,0);
        min.innerHTML = String(minutes).padStart(2,0);
        sec.innerHTML = String(seconds).padStart(2,0);
    }
  
})