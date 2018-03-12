package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Inout_port_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Inout_port_identifierContextExt extends AbstractBaseExt {

	public Inout_port_identifierContextExt(Inout_port_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Inout_port_identifierContext getContext() {
		return (Inout_port_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).inout_port_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Inout_port_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Inout_port_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}