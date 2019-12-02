package data;

typedef WindowData = {
    var name: String;
    var width: Int;
    var height: Int;
    var windowMode: Int;
    var clearColor: Array<Int>;
}

typedef SceneData = {
    public var name: String;
    public var objects: Array<ObjectData>;
    public var ?assets: AssetData;
    public var ?scripts: Array<String>;
    // public var ?physicsWorld: echo.data.Options.WorldOptions;
    public var ?canvasRef: String;
}

typedef AssetData = {
    public var images: Array<String>;
    public var fonts: Array<String>;
    var ?sounds: Array<String>;
    var ?blobs: Array<String>;
}

typedef ObjectData = {
    public var id:Int;
    public var name: String;
    public var x: Float;
    public var y: Float;
    public var height: Float;
    public var width: Float;
    // public var ?rigidBodyData: echo.data.Options.BodyOptions;
    public var ?culled: Bool;
    public var ?spriteRef: String;
    public var ?color: Array<Int>;
    public var ?scripts: Array<ScriptData>;
}

typedef ParticleData = {
    var type:ParticleType;
    var width:Float;
    var ?height:Float;
    var speed: Float;
    var lifeTime: Float;
    var rots: Float;
    var rote: Float;
    var ?color: Array<Int>;
    var ?spriteRef: String;
    var ?controlLifetime: Array<LifetimeAttribute>;
}

typedef EmitterData = {
    var x: Float;
    var y: Float;
    var particle: ParticleData;
    var amount:Int;
}

@:enum abstract ParticleType(Int) from Int to Int {
    var Sprite = 0;
    var Rect = 1;
    var Triangle = 2;
    var Circle = 3;
}

@:enum abstract LifetimeAttribute(Int) from Int to Int {
    var Alpha = 0;
    var Size = 1;
}

typedef ScriptData = {
    var name: String;
    var scriptRef: String;
}

typedef ShaderData = {
    var vertexShader: kha.graphics4.VertexShader;
    var fragmentShader: kha.graphics4.FragmentShader;
}

typedef TweenData = {
	var start: kha.math.Vector2;
	var end: kha.math.Vector2;
	var duration: Float;
	var ease: Null<EaseType>;
	var onDone: Void->Void;
	var ?rotS: Float;
	var ?rotE: Float;
	var ?colourS: Array<Int>;
	var ?colourE: Array<Int>;
	var ?paused:Bool;
	var ?deltaTime: Float;
	var ?done: Bool;
}

@:enum abstract EaseType(Int) from Int to Int {
	var Linear = 0;
	var SineIn = 1;
	var SineOut = 2;
	var SineInOut = 3;
	var QuadIn = 4;
	var QuadOut = 5;
	var QuadInOut = 6;
	var CubicIn = 7;
	var CubicOut = 8;
	var CubicInOut = 9;
	var QuartIn = 10;
	var QuartOut = 11;
	var QuartInOut = 12;
	var QuintIn = 13;
	var QuintOut = 14;
	var QuintInOut = 15;
	var ExpoIn = 16;
	var ExpoOut = 17;
	var ExpoInOut = 18;
	var CircIn = 19;
	var CircOut = 20;
	var CircInOut = 21;
	var BackIn = 22;
	var BackOut = 23;
	var BackInOut = 24;
}