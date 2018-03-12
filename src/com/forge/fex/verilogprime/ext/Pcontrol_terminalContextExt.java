package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pcontrol_terminalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pcontrol_terminalContextExt extends AbstractBaseExt {

	public Pcontrol_terminalContextExt(Pcontrol_terminalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pcontrol_terminalContext getContext() {
		return (Pcontrol_terminalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pcontrol_terminal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pcontrol_terminalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Pcontrol_terminalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}