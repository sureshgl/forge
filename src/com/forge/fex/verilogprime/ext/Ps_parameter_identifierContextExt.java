package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Ps_parameter_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Ps_parameter_identifierContextExt extends AbstractBaseExt {

	public Ps_parameter_identifierContextExt(Ps_parameter_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Ps_parameter_identifierContext getContext() {
		return (Ps_parameter_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).ps_parameter_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Ps_parameter_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Ps_parameter_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}