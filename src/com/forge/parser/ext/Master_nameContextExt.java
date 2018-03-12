package com.forge.parser.ext;

import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Master_nameContext;

public class Master_nameContextExt extends AbstractBaseExt {

	public Master_nameContextExt(Master_nameContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Master_nameContext getContext() {
		return (Master_nameContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).master_name());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Master_nameContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Master_nameContextExt.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
	
	public void collectModulesToStitchForTop(List<String> chain){
		chain.add(getFormattedText());
	}

}
