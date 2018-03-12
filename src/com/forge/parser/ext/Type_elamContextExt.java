package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_elamContext;

public class Type_elamContextExt extends AbstractBaseExt {

	public Type_elamContextExt(Type_elamContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_elamContext getContext() {
		return (Type_elamContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_elam());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_elamContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Type_elamContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
