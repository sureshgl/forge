package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Input_terminalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Input_terminalContextExt extends AbstractBaseExt {

	public Input_terminalContextExt(Input_terminalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Input_terminalContext getContext() {
		return (Input_terminalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).input_terminal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Input_terminalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Input_terminalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}