export const InfiniteScroll = {
  mounted() {
    this.observer = new IntersectionObserver((entries) => {
      const entry = entries[0];

      if (entry.isIntersecting) {
        this.pushEvent("load-more");
      }
    });
    this.observer.observe(this.el);
  },
  beforeDestroy() {
    this.observer.unobserve(this.el);
  },
};
