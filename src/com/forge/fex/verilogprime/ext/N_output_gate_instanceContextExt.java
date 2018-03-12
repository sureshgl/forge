package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.N_output_gate_instanceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class N_output_gate_instanceContextExt extends AbstractBaseExt {

	public N_output_gate_instanceContextExt(N_output_gate_instanceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public N_output_gate_instanceContext getContext() {
		return (N_output_gate_instanceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).n_output_gate_instance());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof N_output_gate_instanceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ N_output_gate_instanceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}