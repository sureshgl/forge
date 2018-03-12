package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Output_port_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Output_port_identifierContextExt extends AbstractBaseExt {

	public Output_port_identifierContextExt(Output_port_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Output_port_identifierContext getContext() {
		return (Output_port_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).output_port_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Output_port_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Output_port_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}