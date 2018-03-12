package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Sim_debugContext;

public class Sim_debugContextExt extends AbstractBaseExt {

	public Sim_debugContextExt(Sim_debugContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sim_debugContext getContext() {
		return (Sim_debugContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sim_debug());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sim_debugContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Sim_debugContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
