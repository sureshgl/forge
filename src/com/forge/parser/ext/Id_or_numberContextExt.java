package com.forge.parser.ext;

import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Id_or_numberContext;

public class Id_or_numberContextExt extends AbstractBaseExt{
	public Id_or_numberContextExt(Id_or_numberContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Id_or_numberContext getContext() {
		return (Id_or_numberContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).id_or_number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Id_or_numberContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Id_or_numberContextExt.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
	
	
	public void resolveParameters(Map<String,String> topModuleParameters){
		super.resolveParameters(topModuleParameters);
		String content = getFormattedText();
		if(topModuleParameters.containsKey(content)){
			setContext(getContext(topModuleParameters.get(content).toString()));
		}
	}
}
