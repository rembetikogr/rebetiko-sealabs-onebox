export default function() {
  this.route("sealabs-onebox", function() {
    this.route("actions", function() {
      this.route("show", { path: "/:id" });
    });
  });
};
