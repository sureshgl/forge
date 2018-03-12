package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Specify_output_terminal_descriptorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Specify_output_terminal_descriptorContextExt extends AbstractBaseExt {

	public Specify_output_terminal_descriptorContextExt(Specify_output_terminal_descriptorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Specify_output_terminal_descriptorContext getContext() {
		return (Specify_output_terminal_descriptorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).specify_output_terminal_descriptor());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Specify_output_terminal_descriptorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Specify_output_terminal_descriptorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}