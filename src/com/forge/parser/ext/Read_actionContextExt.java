package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Read_actionContext;

public class Read_actionContextExt extends AbstractBaseExt {

	public Read_actionContextExt(Read_actionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Read_actionContext getContext() {
		return (Read_actionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).read_action());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Read_actionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Read_actionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
