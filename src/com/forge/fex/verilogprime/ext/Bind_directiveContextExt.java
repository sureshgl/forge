package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bind_directiveContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bind_directiveContextExt extends AbstractBaseExt {

	public Bind_directiveContextExt(Bind_directiveContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bind_directiveContext getContext() {
		return (Bind_directiveContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bind_directive());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bind_directiveContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Bind_directiveContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}