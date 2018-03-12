package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Ps_parameter_identifier_part1Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Ps_parameter_identifier_part1ContextExt extends AbstractBaseExt {

	public Ps_parameter_identifier_part1ContextExt(Ps_parameter_identifier_part1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Ps_parameter_identifier_part1Context getContext() {
		return (Ps_parameter_identifier_part1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).ps_parameter_identifier_part1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Ps_parameter_identifier_part1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Ps_parameter_identifier_part1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}