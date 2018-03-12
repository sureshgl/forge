package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Output_terminalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Output_terminalContextExt extends AbstractBaseExt {

	public Output_terminalContextExt(Output_terminalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Output_terminalContext getContext() {
		return (Output_terminalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).output_terminal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Output_terminalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Output_terminalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}