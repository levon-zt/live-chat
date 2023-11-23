import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"];

  connect() {
    this.scrollDown();
  }

  scrollDown() {
    const elem = this.messageTarget.parentElement.parentElement
    elem.scrollTo(0, 100000);
  }
}