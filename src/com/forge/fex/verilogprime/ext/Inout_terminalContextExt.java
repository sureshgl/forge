package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Inout_terminalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Inout_terminalContextExt extends AbstractBaseExt {

	public Inout_terminalContextExt(Inout_terminalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Inout_terminalContext getContext() {
		return (Inout_terminalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).inout_terminal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Inout_terminalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Inout_terminalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}