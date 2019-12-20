
let plug = new paddy.Plugin();

var khafile = "let project = new Project('New Project');\nproject.addAssets('Assets/**');\nproject.addSources('Sources');\nproject.addLibrary('/Users/urjasvisuthar/Kha2DEngine/Libraries/Rice2D');\nproject.addParameter('scripts');\nproject.addParameter('--macro keep(\"scripts\")');\nresolve(project);";
var main = "package;\nimport rice2d.App;\nclass Main {\npublic static function main() {\nnew App(\"scene\");\n}\n}"

plug.executeRunUI = function (){
    var path = paddy.App.projectPath;
    if (path!="") {
        krom.Kromx.sysCommand(`mkdir ${path}/Sources`);
        krom.Kromx.sysCommand(`cp Assets/mainfont.ttf ${path}/Assets/mainfont.ttf`);
        krom.Kromx.sysCommand(`mkdir ${path}/Sources/scripts`);
        paddy.Export.exportScene(`${path}/Assets`);
        paddy.Export.exportWindow(`${path}/Assets`);
        paddy.Export.exportFile(`${path}/khafile.js`, khafile);
        paddy.Export.exportFile(`${path}/Sources/Main.hx`, main);
        krom.Kromx.sysCommand('echo doesnt work');
        krom.Kromx.sysCommand(`cd ${path}; node /Applications/Blender.app/armsdk/Kha/make krom -g opengl`);
        krom.Kromx.sysCommand(`/Applications/Blender.app/armsdk/Krom/Krom.app/Contents/MacOS/Krom ${path}/build/krom ${path}/build/krom-resources --debug`);
    }
}

var menuHandle = new ui.Handle();

let initNode = {
    id: 0,
    name: "Init",
    type: "InitNode",
    x: 200,
    y: 200,
    inputs: [],
    outputs: [
        {
            id: 0,
            node_id: 0,
            name: "Out",
            type: "ACTION",
            color: 0xffaa4444,
            default_value: ""
        }
    ],
    buttons: [],
    color: 0xff44aa44
}

let nodeCanvas = ui.UINodes.nodeCanvas;
let nodes = ui.UINodes.nodes;

plug.nodeMenuUI = function (ui) {
    if(ui.panel(menuHandle, "Rice2D")){
        if(ui.button("Init")){
            nodeCanvas.nodes.push(paddy.NodeCreator.createNode(initNode, nodes, nodeCanvas));
        }
    }
}
