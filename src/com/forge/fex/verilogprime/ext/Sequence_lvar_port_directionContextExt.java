package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_lvar_port_directionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_lvar_port_directionContextExt extends AbstractBaseExt {

	public Sequence_lvar_port_directionContextExt(Sequence_lvar_port_directionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_lvar_port_directionContext getContext() {
		return (Sequence_lvar_port_directionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_lvar_port_direction());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_lvar_port_directionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequence_lvar_port_directionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}