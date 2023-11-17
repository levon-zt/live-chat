import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["messagesContainer"];

  connect() {
    this.scrollDown();
  }

  scrollDown() {
    const elem = this.messagesContainerTarget;
    elem.scrollTo(0, elem.scrollHeight);
  }
}