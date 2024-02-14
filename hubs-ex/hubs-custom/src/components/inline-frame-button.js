AFRAME.registerComponent("inline-frame-button", {
  schema: {
    name: { default: "" },
    src: { default: "" },
    frameOption: { default: "" }
  },

  init() {
    this.label = this.el.querySelector("[text]");

    this.onClick = async () => {
      const thisSrc = this.data.src;
      const thisSearchParams = new URLSearchParams(thisSrc);
      const params = window.location.search;
      const searchParams = new URLSearchParams(params);
      window.dispatchEvent(new CustomEvent("inline-url", {
         detail: {
           url: searchParams.get(this.data.name) 
           ? `${this.data.src}${thisSearchParams.size > 0 ? "&" : "?"}token=${searchParams.get(this.data.name)}` 
           : this.data.src, 
           option: this.data.frameOption 
          } 
        }
      ))
    };

    NAF.utils.getNetworkedEntity(this.el).then(networkedEl => {
      this.targetEl = networkedEl;
    });
  },

  play() {
    this.el.object3D.addEventListener("interact", this.onClick);
  },

  pause() {
    this.el.object3D.removeEventListener("interact", this.onClick);
  }
});
