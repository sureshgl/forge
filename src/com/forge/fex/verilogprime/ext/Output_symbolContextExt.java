package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Output_symbolContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Output_symbolContextExt extends AbstractBaseExt {

	public Output_symbolContextExt(Output_symbolContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Output_symbolContext getContext() {
		return (Output_symbolContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).output_symbol());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Output_symbolContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Output_symbolContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}