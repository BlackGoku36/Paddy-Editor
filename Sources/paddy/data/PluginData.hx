package paddy.data;

typedef PluginData = {
    var name: String;
    var codeFile: String;
    public var ?propWinUI: zui.Zui->Void;
	public var ?propTabUI: zui.Zui->Void;
	public var ?propObjPanelUI: zui.Zui->Void;
	public var ?propWinPanelUI: zui.Zui->Void;
	public var ?editorTabUI: zui.Zui->Void;
	public var ?editorGridPanelUI: zui.Zui->Void;
	public var ?editorRotPanelUI: zui.Zui->Void;
	public var ?assetWinUI: zui.Zui->Void;
	public var ?sceneWinUI: zui.Zui->Void;
	public var ?update:Void->Void;
}