package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Data_widthContext;

public class Data_widthContextExt extends AbstractBaseExt {

	public Data_widthContextExt(Data_widthContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Data_widthContext getContext() {
		return (Data_widthContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).data_width());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Data_widthContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Data_widthContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
