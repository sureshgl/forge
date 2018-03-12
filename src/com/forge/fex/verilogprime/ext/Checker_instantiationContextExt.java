package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Checker_instantiationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Checker_instantiationContextExt extends AbstractBaseExt {

	public Checker_instantiationContextExt(Checker_instantiationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Checker_instantiationContext getContext() {
		return (Checker_instantiationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).checker_instantiation());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Checker_instantiationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Checker_instantiationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}