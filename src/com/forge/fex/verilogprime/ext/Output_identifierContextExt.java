package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Output_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Output_identifierContextExt extends AbstractBaseExt {

	public Output_identifierContextExt(Output_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Output_identifierContext getContext() {
		return (Output_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).output_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Output_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Output_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}