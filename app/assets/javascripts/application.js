(function(){
    window.onload=()=>{
      document.querySelectorAll(".blog_time").forEach((e)=>{
        let date = new Date(e.innerText);
        e.innerText = date.toLocaleString();
      })
    }
})();
