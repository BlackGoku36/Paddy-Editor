package paddy.data;

import kha.math.FastVector2;

typedef WindowData = {
	var name: String;
	var width: Int;
	var height: Int;
	var windowMode: Int;
	var clearColor: Array<Int>;
}

typedef SceneData = {
	var name: String;
	var objects: Array<ObjectData>;
	var assets: AssetData;
	var ?scripts: Array<String>;
	var ?canvasRef: String;
}

typedef AssetData = {
	var images: Array<String>;
	var ?fonts: Array<String>;
	var ?sounds: Array<String>;
	var ?blobs: Array<String>;
}

typedef ObjectData = {
	var id:Int;
	var name: String;
	var x: Float;
	var y: Float;
	var height: Float;
	var width: Float;
	var isSprite:Bool;
	var ?rotation:Float;
	var ?visible:Bool;
	var ?culled: Bool;
	var ?spriteRef: String;
	var ?color: Array<Int>;
	var ?scripts: Array<ScriptData>;
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
	var start: FastVector2;
	var end: FastVector2;
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
