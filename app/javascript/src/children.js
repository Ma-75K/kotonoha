document.addEventListener("turbo:load", () => {
  const addButton = document.getElementById("add-child-button");
  const container = document.getElementById("children-fields");

  if (!addButton || !container) return;

  let childIndex = container.querySelectorAll(".child-fields").length;

  addButton.addEventListener('click', () => {
    const newField = document.createElement("div");
    newField.classList.add("child-fields", "mb-4");

    newField.innerHTML = `
      <div class="mb-3">
        <label class="form-label" for="user_children_attributes_${childIndex}_name">お子さまのお名前</label>
        <input class="form-control" type="text" name="user[children_attributes][${childIndex}][name]" id="user_children_attributes_${childIndex}_name">
      </div>

      <div class="mb-3">
        <label class="form-label" for="user_children_attributes_${childIndex}_birthday">生年月日</label>
        <input class="form-control" type="date" name="user[children_attributes][${childIndex}][birthday]" id="user_children_attributes_${childIndex}_birthday">
      </div>
    `;

    container.appendChild(newField);
    childIndex += 1;
  });
});
