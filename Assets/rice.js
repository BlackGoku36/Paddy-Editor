
let plug = new paddy.Plugin();

var khafile = "let project = new Project('New Project');\nproject.addAssets('Assets/**');\nproject.addSources('Sources');\nproject.addLibrary('/Users/urjasvisuthar/Kha2DEngine/Libraries/Rice2D');\nproject.addLibrary('/Users/urjasvisuthar/Kha2DEngine/Libraries/zui');\nproject.addParameter('rice2d.node');\nproject.addDefine('rice_debug');\nproject.addParameter('scripts');\nproject.addParameter('--macro keep(\"scripts\")');\nresolve(project);";
var main = "package;\nimport rice2d.App;\nclass Main {\npublic static function main() {\nnew App(\"scene\");\n}\n}"

plug.executeRunUI = function (){
    var path = paddy.App.projectPath;
    if (path!="") {
        kha.TKrom.sysCommand(`mkdir ${path}/Sources`);
        kha.TKrom.sysCommand(`mkdir ${path}/Sources/scripts`);
        kha.TKrom.sysCommand(`cp Assets/mainfont.ttf ${path}/Assets/mainfont.ttf`);
        paddy.Export.exportScene(`${path}/Assets`);
        paddy.Export.exportWindow(`${path}/Assets`);
        paddy.Export.exportNodes(`${path}/Assets`);
        paddy.Export.exportFile(`${path}/khafile.js`, khafile);
        paddy.Export.exportFile(`${path}/Sources/Main.hx`, main);
        kha.TKrom.sysCommand(`cd ${path}; node /Users/urjasvisuthar/Kha/make krom -g opengl`);
        kha.TKrom.sysCommand(`/Applications/Blender.app/armsdk/Krom/Krom.app/Contents/MacOS/Krom ${path}/build/krom ${path}/build/krom-resources`);
    }
}

var menuHandle = new zui.Handle();

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

// let nodeCanvas = paddy.UINodes.selectedNode.nodeCanvas;
// let nodes = paddy.UINodes.selectedNode.nodes;

plug.nodeMenuUI = function (ui) {
    if(ui.panel(menuHandle, "Rice2D")){
        if(ui.button("Init")){
            paddy.UINodes.selectedNode.nodeCanvas.nodes.push(paddy.NodeCreator.createNode(initNode, paddy.UINodes.selectedNode.nodes, paddy.UINodes.selectedNode.nodeCanvas));
        }
    }
}
