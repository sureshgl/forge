package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Ncontrol_terminalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Ncontrol_terminalContextExt extends AbstractBaseExt {

	public Ncontrol_terminalContextExt(Ncontrol_terminalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Ncontrol_terminalContext getContext() {
		return (Ncontrol_terminalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).ncontrol_terminal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Ncontrol_terminalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Ncontrol_terminalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}