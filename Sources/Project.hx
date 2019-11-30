package;

import kha.Framebuffer;

class Project {

    public function new() {
        trace("new");
    }

    public function update() {
        trace("update");
    }

    public function render(frame:Array<Framebuffer>) {
        frame[0].g2.begin();
        frame[0].g2.fillRect(0, 0, 100, 100);
        frame[0].g2.end();
    }
}