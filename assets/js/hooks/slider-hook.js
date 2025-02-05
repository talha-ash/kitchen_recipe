export const SliderHook = {
  mounted() {
    const showValueEle = this.el.parentElement.querySelector(".range-value");
    this.el.addEventListener("input", (e) => {
      showValueEle.textContent = e.target.value;
    });

    this.el.addEventListener("mouseup", (e) => {
      showValueEle.textContent = e.target.value;
      this.pushEvent("range-input-change", {
        name: e.target.name,
        value: e.target.value,
      });
    });
  },
  destroyed() {
    this.el.removeEventListener("input");
    this.el.removeEventListener("mouseup");
  },
};
