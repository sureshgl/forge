package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Sim_debug_identifierContext;

public class Sim_debug_identifierContextExt extends AbstractBaseExt {

	public Sim_debug_identifierContextExt(Sim_debug_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sim_debug_identifierContext getContext() {
		return (Sim_debug_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sim_debug_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sim_debug_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sim_debug_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
