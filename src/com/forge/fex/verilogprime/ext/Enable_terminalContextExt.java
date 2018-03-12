package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Enable_terminalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Enable_terminalContextExt extends AbstractBaseExt {

	public Enable_terminalContextExt(Enable_terminalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Enable_terminalContext getContext() {
		return (Enable_terminalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).enable_terminal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Enable_terminalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Enable_terminalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}