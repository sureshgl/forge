package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_slave_actionContext;

public class Type_slave_actionContextExt extends AbstractBaseExt {

	public Type_slave_actionContextExt(Type_slave_actionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_slave_actionContext getContext() {
		return (Type_slave_actionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_slave_action());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_slave_actionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_slave_actionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
