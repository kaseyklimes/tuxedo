import $ from 'jquery';

export default class Image {
  constructor($image) {
    this.image = $image;
    console.log(src)
    this.src = $image.attr("data-lazy-load");
  }

  upscale() {
    var self = this;
    var img = self.image.clone().attr("src", this.src);
    console.log(img)
    img.on("load", () => self.image.replaceWith(img));
  }
}
