import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal", "usersList", "saerchTerm"];

  connect() {
    const myModal = new bootstrap.Modal(this.modalTarget);
    //myModal.show();
  }

  submit() {
    fetch(`/chats/search?search_term=${this.saerchTermTarget.value}`, {
      method: 'GET'
    })
    .then(res => res.json())
    .then(res => {
      console.log(res)
      this.usersListTarget.textContent = "hello";
    })

  }
}