package mockatoo.macro;


#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using tink.MacroApi;

class Types
{
	
	/**
	Returns the default 'null' value for a type.

	On static platforms (Flash, CPP, Java, C#), basic types have their own default values :

	every Int is by default initialized to 0
	every Float is by default initialized to NaN on Flash9+, and to 0.0 on CPP, Java and C#
	every Bool is by default initialized to false
	*/
	static public function defaultValue(type:ComplexType):Expr
	{
		if(type == null)
			return EConst(CIdent("null")).at();

		if(Contexts.isStaticPlatform())
		{
			switch(type)
			{
				case TPath(p):
				{
					if(p.pack.length != 0) return EConst(CIdent("null")).at();

					if(p.name == "StdTypes") p.name = p.sub;

					switch(p.name)
					{
						case "Bool":
							return EConst(CIdent("false")).at();
						case "Int":
							return EConst(CInt("0")).at();
						case "Float":
							if( Context.defined("flash"))
								return "Math.NaN".resolve();
							else
								return EConst(CFloat("0.0")).at();
						default: null;
					}	
				}
				default: null;
			}
		}
		return EConst(CIdent("null")).at();
	}

}

#end