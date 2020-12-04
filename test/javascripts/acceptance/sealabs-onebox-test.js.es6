import { acceptance } from "discourse/tests/helpers/qunit-helpers";

acceptance("SealabsOnebox", { loggedIn: true });

test("SealabsOnebox works", async assert => {
  await visit("/admin/plugins/sealabs-onebox");

  assert.ok(false, "it shows the SealabsOnebox button");
});
