package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Hint_zerotime_actionContext;

public class Hint_zerotime_actionContextExt extends AbstractBaseExt {

	public Hint_zerotime_actionContextExt(Hint_zerotime_actionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hint_zerotime_actionContext getContext() {
		return (Hint_zerotime_actionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hint_zerotime_action());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hint_zerotime_actionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Hint_zerotime_actionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
