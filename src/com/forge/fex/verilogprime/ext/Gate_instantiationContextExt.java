package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Gate_instantiationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Gate_instantiationContextExt extends AbstractBaseExt {

	public Gate_instantiationContextExt(Gate_instantiationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Gate_instantiationContext getContext() {
		return (Gate_instantiationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).gate_instantiation());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Gate_instantiationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Gate_instantiationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}