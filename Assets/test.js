
let plug = new paddy.Plugin();

let h1 = new ui.Handle();

plug.drawUI = function (ui) {
    ui.button("Hello!");
    var cof = paddy.App.coffX;
    ui.button(cof+"");
}
