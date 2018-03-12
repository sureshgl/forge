package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_fieldContext;

public class Type_fieldContextExt extends AbstractBaseExt {

	public Type_fieldContextExt(Type_fieldContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_fieldContext getContext() {
		return (Type_fieldContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_field());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_fieldContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Type_fieldContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
