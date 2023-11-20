import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["userContainer"];

  submit() {
    const form = this.userContainerTarget;
    form.submit();
  }
}